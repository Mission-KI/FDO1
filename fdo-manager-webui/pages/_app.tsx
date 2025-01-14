import { AuthProvider, Refine } from '@refinedev/core'
import { RefineKbar, RefineKbarProvider } from '@refinedev/kbar'
import {
  RefineSnackbarProvider,
  ThemedLayoutV2,
  ThemedTitleV2,
  ThemedSiderV2,
  notificationProvider
} from '@refinedev/mui'
import routerProvider from '@refinedev/nextjs-router'
import {
  UnsavedChangesNotifier
} from '@refinedev/nextjs-router/pages'
import type { NextPage } from 'next'
import { SessionProvider, signIn, signOut, useSession } from 'next-auth/react'
import { AppProps } from 'next/app'
import { usePathname } from 'next/navigation'
import React from 'react'

import { Header } from '@components/header'
import { ColorModeContextProvider } from '@contexts'
import CssBaseline from '@mui/material/CssBaseline'
import GlobalStyles from '@mui/material/GlobalStyles'
import dataProvider from '../src/providers/dataProvider'
import { appWithTranslation, useTranslation } from 'next-i18next'
import logo from '../src/components/fdo_logo'
import { API_URL } from '../src/constants'
import StorageIcon from '@mui/icons-material/Storage'
import FactCheckIcon from '@mui/icons-material/FactCheck'
import LightbulbIcon from '@mui/icons-material/Lightbulb'
import Typography from '@mui/material/Typography'
import Link from '@mui/material/Link'

export type NextPageWithLayout<P = {}, IP = P> = NextPage<P, IP> & {
  noLayout?: boolean
}

type AppPropsWithLayout = AppProps & {
  Component: NextPageWithLayout
}

const App = (props: React.PropsWithChildren) => {
  const { t, i18n } = useTranslation()

  const { data, status, error } = useSession()
  const to = usePathname()

  const i18nProvider = {
    translate: (key: string, params: object) => t(key, params),
    changeLocale: async (lang: string) => await i18n.changeLanguage(lang),
    getLocale: () => i18n.language
  }

  if (status === 'loading') {
    return <span>loading...</span>
  }

  const authProvider: AuthProvider = {
    login: async () => {
      await signIn('keycloak')

      return {
        success: true
      }
    },
    logout: async () => {
      signOut()

      return {
        success: true,
      }
    },
    onError: async (error) => {
      // console.error("onError", error)
      return {
        error
      }
    },
    check: async () => {
      // console.log("check", data, error, status)
      if (status === 'unauthenticated') {
        return {
          authenticated: false,
          redirectTo: '/login'
        }
      }

      if(data?.error) {
        return {
          error: error,
          authenticated: false,
          redirectTo: '/login'
        }
      }

      return {
        authenticated: true
      }
    },
    getPermissions: async () => {
      return null
    },
    getIdentity: async () => {
      // console.log("getIdentity", data, error, status);
      if(data?.error) {
        return {
          error: error,
          authenticated: false,
          redirectTo: '/login'
        }
      }

      if (data?.user && status === "authenticated") {
        const { user } = data
        return {
          name: user.name,
          avatar: user.image,
          data
        }
      }

      return null
    }
  }

  return <>
    <RefineKbarProvider>
      <ColorModeContextProvider>
        <CssBaseline />
        <GlobalStyles styles={{ html: { WebkitFontSmoothing: 'auto' } }} />
        <RefineSnackbarProvider>
          <Refine
            routerProvider={routerProvider}
            dataProvider={dataProvider(API_URL)}
            notificationProvider={notificationProvider}
            authProvider={authProvider}
            i18nProvider={i18nProvider}
            options={{
              disableTelemetry: true,
              syncWithLocation: true,
              warnWhenUnsavedChanges: true,
              useNewQueryKeys: true
            }}
            resources={[{
              name: 'fdo',
              list: '/fdo',
              show: '/fdo/show/:prefix/:suffix',
              create: '/fdo/create',
              meta: {
                icon: logo
              }
            }, {
              name: 'repositories',
              list: '/repositories',
              show: '/repositories/show/:id',
              meta: {
                icon: <StorageIcon/>
              }
            }, {
              name: 'profiles',
              identifier: 'profiles',
              list: '/profiles',
              show: '/profiles/show/:id',
              meta: {
                icon: <FactCheckIcon/>
              }
            }, {
              name: 'about',
              identifier: 'about',
              list: '/about',
              meta: {
                label: 'About',
                icon: <LightbulbIcon/>
              }
            }]}
          >
            {props.children}
            <RefineKbar />
            <UnsavedChangesNotifier />
          </Refine>
        </RefineSnackbarProvider>
      </ColorModeContextProvider>
    </RefineKbarProvider>
  </>
}

function MyApp ({
  Component,
  pageProps: { session, ...pageProps }
}: AppPropsWithLayout): JSX.Element {
  const renderComponent = () => {
    if (Component.noLayout) {
      return <Component {...pageProps} />
    }

    return (
      <ThemedLayoutV2
        Footer={() => <Typography align="right" variant="caption" sx={{ marginRight: '0.5rem' }}><Link href="https://www.indiscale.com">© 2024 IndiScale GmbH</Link></Typography>}
        Header={() => <Header sticky />}
        Sider={() => <ThemedSiderV2
          render={({ dashboard, logout, items, collapsed }) => {
            return <>{dashboard}{items}</>
          }}
          Title={({ collapsed }) => (
            <ThemedTitleV2
              collapsed={collapsed}
              text="FDO Manager"
              icon={logo}
            />
          )}
          />}
        >
        <Component {...pageProps} />
      </ThemedLayoutV2>
    )
  }

  return (
    <SessionProvider session={session}
            refetchOnWindowFocus={true}
    >
      <App>{renderComponent()}</App>
    </SessionProvider>
  )
}

export default appWithTranslation(MyApp)
