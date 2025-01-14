import NextAuth from 'next-auth'
import KeycloakProvider from 'next-auth/providers/keycloak'

const secretSessionKey = process.env.SECRET_SESSION_KEY || 'UItTuD1HcGXIj8ZfHUswhYdNd40Lc325R8VlxQPUoR0='
const clientId = process.env.KEY_CLOAK_CLIENT_ID || 'gwdg-fdoman-test'
const clientSecret = process.env.KEY_CLOAK_CLIENT_SECRET || ''
const issuer = process.env.KEY_CLOAK_ISSUER || 'https://keycloak.sso.gwdg.de/auth/realms/academiccloud'

async function refreshAccessToken (token: any) {
  try {
    const url = issuer + '/protocol/openid-connect/token'
    const params = new URLSearchParams({
      client_id: clientId!,
      client_secret: clientSecret!,
      grant_type: 'refresh_token',
      refresh_token: token.refresh_token!,
    }).toString()

    const response = await fetch(url, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      method: 'POST',
      body: params
    })

    const new_tokens = await response.json()

    if (!response.ok) {
      throw new_tokens
    }
    // console.log('### new_tokens', new Date().toISOString(), new_tokens, '### ### ###')

    return {
      ...token,
      access_token: new_tokens.access_token,
      expires_at: Math.floor(Date.now()/1000 + new_tokens.expires_in),
      refresh_token: new_tokens.refresh_token ?? token.refresh_token // Fall back to old refresh token
    }
  } catch (error) {
    // console.log('### RefreshAccessTokenError', error, '### ### ###')
    throw new Error("RefreshTokenError")

    /*
    return {
      ...token,
      error: 'RefreshAccessTokenError'
    }
    */
  }
}

export const authOptions = {
  // adapter: UnstorageAdapter(storage),
  session: {
    maxAge: 172800 // 48h
  },
  // Configure one or more authentication providers
  providers: [
    // !!! Should be stored in .env file.
    KeycloakProvider({
      clientId,
      clientSecret,
      issuer,
      // authorization: { params: { scope: 'openid profile email' } },
      profile (profile) {
        // console.log('### profile', profile, '### ### ###')
        return {
          id: profile.sub,
          name: profile.name ?? profile.preferred_username
        }
      }
    })
  ],
  callbacks: {
    async signIn ({ user, account, profile, email, credentials }: any) {
      // console.log('### signIn', user, account, profile, email, credentials, '### ### ###')
      return true
    },
    async session ({ session, user, token }: any) {
      // console.log('### session', session, user, token, '### ### ###')

      session.user = token.user
      session.access_token = token.access_token
      session.error = token.error

      return session
    },
    /*
    async redirect ({ url, baseUrl }: any) {
      // console.log('### redirect', url, baseUrl, '### ### ###')
      return baseUrl
      //Promise.resolve(url)
    },
    */
    async jwt ({ token, user, account, profile, isNewUser }: any) {
      // console.log('### jwt', token, user, account, profile, isNewUser, '### ### ###')

      // Initial sign in
      if (account && user) {
        return {
          access_token: account.access_token,
          expires_at: account.expires_at,
          refresh_token: account.refresh_token,
          user
        }
      } else if (Date.now() < token.expires_at * 1000) {
        return token
      } else {
        if (!token.refresh_token) throw new TypeError("Missing refresh_token")

        // Access token has expired, try to update it
        return refreshAccessToken(token)
      }
    }
  },
  secret: secretSessionKey
}
export default NextAuth(authOptions)
