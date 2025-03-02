import Box from '@mui/material/Box'
import Button from '@mui/material/Button'
import Container from '@mui/material/Container'
import Typography from '@mui/material/Typography'
import { useLogin, useTranslate } from '@refinedev/core'
import { ThemedTitleV2 } from '@refinedev/mui'

import { GetServerSideProps } from 'next'
import { serverSideTranslations } from 'next-i18next/serverSideTranslations'

import { getServerSession } from 'next-auth'
import { authOptions } from '../api/auth/[...nextauth]'

import logo from '../../src/components/fdo_logo'

export default function Login () {
  const { mutate: login } = useLogin()

  const t = useTranslate()

  return (
    <Container
      style={{
        height: '100vh',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center'
      }}
    >
      <Box
        display="flex"
        gap="36px"
        justifyContent="center"
        flexDirection="column"
      >
        <ThemedTitleV2
          text="FDO Manager"
          icon={logo}
          collapsed={false}
          wrapperStyles={{
            fontSize: '22px',
            justifyContent: 'center'
          }}
        />

        <Button
          style={{ width: '240px' }}
          size="large"
          variant="contained"
          onClick={() => { login({}) }}
        >
          {t('pages.login.signin', 'Sign in')}
        </Button>
        <Typography align="center" color={'text.secondary'} fontSize="12px">
          Powered by
          <img
            style={{ padding: '0 5px' }}
            alt="Keycloak"
            src="https://refine.ams3.cdn.digitaloceanspaces.com/superplate-auth-icons%2Fkeycloak.svg"
          />
          Keycloak
        </Typography>
      </Box>
    </Container>
  )
}

Login.noLayout = true

export const getServerSideProps: GetServerSideProps<{}> = async (context) => {
  const session = await getServerSession(context.req, context.res, authOptions)

  const translateProps = await serverSideTranslations(context.locale ?? 'en', [
    'common'
  ])

  // console.log("login", context, session);
  const destination = context?.query?.to

  if (session) {
    return {
      props: {
        ...translateProps
      },
      redirect: {
        destination: destination || '/',
        permanent: false
      }
    }
  }

  return {
    props: {
      ...translateProps
    }
  }
}
