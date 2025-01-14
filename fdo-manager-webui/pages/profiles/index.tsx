import React from 'react'
import { GetServerSideProps } from 'next'
import { serverSideTranslations } from 'next-i18next/serverSideTranslations'

import { ProfilesList } from '../../src/components/profiles'

const ListProfiles = () => {
  return <ProfilesList/>
}

export default ListProfiles

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
