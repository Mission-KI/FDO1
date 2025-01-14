import React from 'react'
import { ErrorComponent } from '../src/components/ErrorComponent'
import { GetServerSideProps } from 'next'
import { serverSideTranslations } from 'next-i18next/serverSideTranslations'
import { useTranslate } from '@refinedev/core'

export default function NotFound (props: any) {
  const translate = useTranslate()
  console.log('NotFOUND: ', props, translate('pages.error.404'))
  return <ErrorComponent />
}

export const getStaticProps = async (props: any) => {
  const translateProps = await serverSideTranslations(props.locale ?? 'en', [
    'common'
  ])
  console.log('getStaticProps', props, await serverSideTranslations('en', ['common']))
  return {
    props: {
      ...translateProps,
      lang: 'en'
    }
  }
}
