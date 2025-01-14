import React from 'react'
import Stack from '@mui/material/Stack'
import Paper from '@mui/material/Paper'
import Box from '@mui/material/Box'
import { styled } from '@mui/material/styles'
import { FDO_MANAGER_WEBUI_VERSION } from '../../src/constants'
import { GetServerSideProps } from 'next'
import { serverSideTranslations } from 'next-i18next/serverSideTranslations'

import { useTranslate, useOne, useShow, useApiUrl } from '@refinedev/core'
import { List } from '@refinedev/mui'
import Link from '@mui/material/Link'
import Card from '@mui/material/Card'
import IndiScaleCard from '../../src/components/IndiScaleCard'
import GWDGCard from '../../src/components/GWDGCard'
import CardContent from '@mui/material/CardContent'

const Item = styled(Paper)(({ theme }) => ({
  backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
  ...theme.typography.body2,
  padding: theme.spacing(1),
  marginTop: '1rem',
  textAlign: 'left',
  color: theme.palette.text.secondary
}))

const Info = () => {
  const { queryResult: { data, isLoading } } = useShow({ resource: 'info', id: '' })
  const t = useTranslate()
  const info = t('about.info', 'This is the FDO Manager. The hardware and infrastructure for this test instance are provided by GWDG. IndiScale is responsible for the architecture and implementation.')

  const apiUrl = useApiUrl()

  return (
    <List title="About">
    <Box>
    <Stack spacing="3rem" >
      <Card sx={{ maxWidth: 480 }}>
      <CardContent>
         {info}
      <Item>FDO Manager WebUI Version: {FDO_MANAGER_WEBUI_VERSION}</Item>
      <Item>FDO Manager Service Version: {data?.data?.fdoServiceVersion}</Item>
      <Item>FDO Manager API endpoint: <Link href={apiUrl} target="_blank" rel="noopener">{apiUrl}</Link></Item>
      <Item>FDO Manager SDK Version: {data?.data?.fdoSdkVersion}</Item>
      <Item>{t('about.sourceCode', 'Source Code')} <Link href="https://gitlab.com/fairdo">gitlab.com/fairdo</Link></Item>
      </CardContent>
      </Card>
      <IndiScaleCard/>
      <GWDGCard/>
    </Stack>
    </Box>
    <Box>
    </Box>
    </List>
  )
}

export default Info

export const getServerSideProps: GetServerSideProps<{}> = async (context) => {
  const translateProps = await serverSideTranslations(context.locale ?? 'en', [
    'common'
  ])

  return {
    props: {
      ...translateProps
    }
  }
}
