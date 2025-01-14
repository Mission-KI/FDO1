import React from 'react'
import { useTranslate, useCustom, useApiUrl } from '@refinedev/core'
import CircularProgress from '@mui/material/CircularProgress'
import Box from '@mui/material/Box'
import Link from '@mui/material/Link'
import Paper from '@mui/material/Paper'
import Typography from '@mui/material/Typography'
import { FDO_COMMUNITY_MD_PROFILE_AAS as AAS, HANDLE_SYSTEM_BASE_URI as HS_BASE_URI, HANDLE_SYSTEM_DOWNLOAD_PROXY as HS_PROXY, CORDRA_HANDLE as CORDRA } from '../constants'
import { JsonView, darkStyles, defaultStyles } from 'react-json-view-lite';
import { styled } from '@mui/material/styles'
import 'react-json-view-lite/dist/index.css';

import Details from '@components/fdos/details'

const resolvePid = (pid) => `${HS_BASE_URI}/${pid}`

const Item = styled(Paper)(({ theme }) => ({
  backgroundColor: '#fff',
  ...theme.typography.body2,
  padding: theme.spacing(1),
  textAlign: 'left',
  color: theme.palette.text.secondary,
  ...theme.applyStyles('dark', {
    backgroundColor: '#1A2027'
  })
}))

const getEvebsDetails = (typePid, repository, metadataRecord) => {
  const row = (category, classification, logo) => {
    return { category, classification, logo }
  }
  const techInfo = metadataRecord.fdoProfile === AAS ? "BaSyx AAS" : "EDC";
  const techLogo = metadataRecord.fdoProfile === AAS ? "/images/aas.png" : "/images/eclipse-logo.png";
  const dataspaceInfo = metadataRecord.fdoProfile === AAS ? "RWTH" : "MDS";
  const dataspaceLogo = metadataRecord.fdoProfile === AAS ? "/images/rwth.png" : "/images/mds.png";

  const details = [
    row('Type', <Link href={resolvePid(typePid)}>{ "EVEBS-FDO" }</Link>, '')
  ]
  if(repository) {
    details.push(row('Repository', repository,
        repository == CORDRA ? "/images/cordra-primary-blue.png" : "/images/la_logo.png"))
  }
  details.push(row('Dataspace', dataspaceInfo, dataspaceLogo))
  details.push(row('Technology', techInfo, techLogo))
  return details
}

const EvebsDetails = ({pid, typePid, repository, metadataPid, title, showJson, subtitle}) => {
  const apiUrl = useApiUrl()
  const t = useTranslate()
  const { data, isLoading, isError, error } = useCustom({
    url: `${HS_PROXY}/${metadataPid}?locatt=payloadIndex:0`,
    method: 'get',
    errorNotification: () => false,
    queryOptions: {
      retry: false
    }
  })
  const metadataRecord = useCustom({
    url: `${apiUrl}/fdo/${metadataPid}`,
    method: 'get',
    errorNotification: () => false,
    queryOptions: {
      retry: false
    }
  });

  const metadata = data?.data;
  var description = undefined
  var displayName = metadata?.displayName
  if(displayName && displayName[0]) {
    displayName = displayName[0].text
  }
  if(isError) {
    displayName = pid
  } else if(metadata?.description && metadata?.description[0]) {
    description = metadata?.description[0].text
  }

  if (metadataRecord.isError) {
    return <Item>Error</Item>
  }

  return isLoading || metadataRecord.isLoading ? <Item><CircularProgress/></Item> : (
    <>
      <Item>
        <Typography variant="h5" gutterBottom>{title || displayName || metadata?.idShort || metadata?.id}</Typography>
        <Typography variant="subtitle1" gutterBottom>{subtitle || description}</Typography>
        <Box>
        <Details rows={getEvebsDetails(typePid, repository, metadataRecord.data.data)}></Details>
        </Box>
      </Item>
      { metadata && showJson &&
        <Item>
          <Box>
            <Typography variant="h6" gutterBottom>Metadata (JSON)</Typography>
            <JsonView data={metadata} shouldExpandNode={lvl => lvl<3} style={defaultStyles} />
          </Box>
        </Item>
      }
    </>
  )
}

export default EvebsDetails
