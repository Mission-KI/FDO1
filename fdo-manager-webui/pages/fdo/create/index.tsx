import React from 'react'

import { Authenticated } from '@refinedev/core'
import { FdoCreate } from '../../../src/components/fdos'
import { GetServerSideProps } from 'next'
import { serverSideTranslations } from 'next-i18next/serverSideTranslations'

const CreateFDO = () => {
  return (
  <Authenticated key="fdo-create">
    <FdoCreate/>
  </Authenticated>)
}

export default CreateFDO

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
