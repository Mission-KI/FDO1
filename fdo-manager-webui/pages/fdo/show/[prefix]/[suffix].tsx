import React from 'react'

import { ErrorComponent } from '../../../../src/components/ErrorComponent'
import { GetServerSideProps } from 'next'
import { serverSideTranslations } from 'next-i18next/serverSideTranslations'
import { useTranslate, useParsed, useCustom, useApiUrl } from '@refinedev/core'
import { Show } from '@refinedev/mui'
import Typography from '@mui/material/Typography'
import CircularProgress from '@mui/material/CircularProgress'
import Box from '@mui/material/Box'
import Stack from '@mui/material/Stack'
import Chip from '@mui/material/Chip'
import Link from '@mui/material/Link'
import StorageIcon from '@mui/icons-material/Storage'
import Paper from '@mui/material/Paper'
import RadioButtonUncheckedIcon from '@mui/icons-material/RadioButtonUnchecked'
import Divider from '@mui/material/Divider'
import MenuList from '@mui/material/MenuList'
import MenuItem from '@mui/material/MenuItem'
import ListItemText from '@mui/material/ListItemText'
import ListItemIcon from '@mui/material/ListItemIcon'
import VerifiedIcon from '@mui/icons-material/Verified'
import ReportIcon from '@mui/icons-material/Report'
import { styled } from '@mui/material/styles'
import EvebsDetails from '@components/Evebs'
import { FDO_COMMUNITY_TYPE_EVEBS as EVEBS, HANDLE_SYSTEM_BASE_URI as HS_BASE_URI } from '../../../../src/constants'

const resolvePid = (pid: string) => `${HS_BASE_URI}/${pid}`

const getFdoDetails = (data: object) => {
  if(!data) return {};

  const fdoDetails = {
    pid: data["pid"],
    isFdo: data["isFdo"],
    typePid: data["fdoType"],
    profilePid: data["fdoProfile"],
    dataPid: data["dataPid"],
    metadataPid: data["metadataPid"],
    repository: undefined,
    attributes: data["attributes"],
  }
  if(data.attributes) {
    fdoDetails["repository"] = data.attributes["0.TYPE/DOIPService"]
  }

  return fdoDetails
}


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

const ShowFDO = () => {
  const { params } = useParsed()
  const showId = `${params?.prefix}/${params?.suffix}`
  const apiUrl = useApiUrl()
  const t = useTranslate()
  const { data, isLoading, isError, error } = useCustom({
    url: `${apiUrl}/fdo/${showId}`,
    method: 'get',
    errorNotification: () => false,
    queryOptions: {
      retry: false
    }
  })

  if (isError) {
    return <ErrorComponent message={t('fdo.show.handle_not_found', 'Handle not found.')} />
  }

  const handleUrl = resolvePid(showId)
  const dataPid = data?.data?.dataPid
  const metadataPid = data?.data?.metadataPid

  const fdoDetails = getFdoDetails(data?.data);
  const isEvebs = fdoDetails?.typePid === EVEBS

  return (
    <Show
      isLoading={isLoading}
      title={<Typography variant="h5">{ showId }

        { !isLoading && (data?.data?.isFdo ? <Chip label="FDO" color="success" variant="outlined" sx={{marginLeft: 1}}/> : <Chip label="Not an FDO" color="error" variant="outlined" sx={{marginLeft: 1}}/>)}
        </Typography>}
    >
      { isLoading && <Box sx={{ textAlign: 'center' }}><CircularProgress/></Box>}

      <div>
        <Stack
        direction="row"
        // divider={<Divider orientation="vertical" flexItem />}
        spacing={2}
        >
          <Item>
            <MenuList>
              <MenuItem>
                <ListItemIcon>
                  <RadioButtonUncheckedIcon/>
                </ListItemIcon>
                <ListItemText>
                    <Link href={`${handleUrl}?noredirect`}>Handle Record</Link>
                </ListItemText>
              </MenuItem>
              <MenuItem>
                <ListItemIcon>
                  <StorageIcon/>
                </ListItemIcon>
                <ListItemText>
                  <Link href={handleUrl}>To Repository</Link>
                </ListItemText>
              </MenuItem>
                { data?.data?.isFdo && (<>
                  <Divider />
              <MenuItem>
                <ListItemIcon>
                  { dataPid
                    ? <VerifiedIcon color="success"/>
                    : <ReportIcon color="error"/>
                  }
                </ListItemIcon>
                <ListItemText>
                  { metadataPid
                    ? <Link href={resolvePid(dataPid)}>Data</Link>
                    : 'Data not available.'
                  }
                </ListItemText>
              </MenuItem>
              <MenuItem>
                <ListItemIcon>
                  { metadataPid
                    ? <VerifiedIcon color="success"/>
                    : <ReportIcon color="error"/>
                  }
                </ListItemIcon>
                <ListItemText>
                  { metadataPid
                    ? <Link href={resolvePid(metadataPid)}>Metadata</Link>
                    : 'Metadata not available.'
                  }
                </ListItemText>
              </MenuItem>
              <MenuItem>
                <ListItemIcon>
                  { fdoDetails.profilePid
                    ? <VerifiedIcon color="success"/>
                    : <ReportIcon color="error"/>
                  }
                </ListItemIcon>
                <ListItemText>
                  { fdoDetails.profilePid
                    ? <Link href={resolvePid(fdoDetails.profilePid)}>Profile</Link>
                    : 'Profile not available.'
                  }
                </ListItemText>
              </MenuItem>
              </>)}
            </MenuList>
          </Item>

          { isEvebs && <EvebsDetails {...fdoDetails} showJson={true}/> }
        </Stack>
      </div><br/><br/>
    </Show>
  )
}

export default ShowFDO

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
