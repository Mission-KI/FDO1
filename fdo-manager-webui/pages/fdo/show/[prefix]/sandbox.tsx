import React from 'react'
import { ErrorComponent } from '../../../../src/components/ErrorComponent'
import { GetServerSideProps } from 'next'
import { serverSideTranslations } from 'next-i18next/serverSideTranslations'
import { useShow, useTranslate, useParsed, useCustom, useApiUrl } from '@refinedev/core'
import { Show } from '@refinedev/mui'
import { Typography } from '@mui/material'
import CircularProgress from '@mui/material/CircularProgress'
import AssignmentIcon from '@mui/icons-material/Assignment'
import Avatar from '@mui/material/Avatar'
import { blue } from '@mui/material/colors'
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
import { styled, ThemeProvider } from '@mui/material/styles'
import Details from '../../../../src/components/fdos/details'

const resolvePid = (pid: string) => `https://hdl.handle.net/${pid}`

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
  const displayName = 'FDO-Name'
  const genInfo = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore voluptua.'
  const handleUrl = resolvePid(showId)
  const dataPid = data?.data?.dataPid
  const metadataPid = data?.data?.metadataPid
  const profilePid = '21.T11969/141bf451b18a79d0fe66'
  const Item = styled(Paper)(({ theme }) => ({
    backgroundColor: '#fff',
    ...theme.typography.body2,
    padding: theme.spacing(1),
    textAlign: 'center',
    color: theme.palette.text.secondary,
    ...theme.applyStyles('dark', {
      backgroundColor: '#1A2027'
    })
  }))

  return (
    <Show
      isLoading={isLoading}
      title={<Typography variant="h5">{ showId }{ !isLoading && (data?.data?.isFdo ? <Chip label="FDO" color="success" variant="outlined" /> : <Chip label="Not an FDO" color="error" variant="outlined" />)}</Typography>}
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
                  { profilePid
                    ? <VerifiedIcon color="success"/>
                    : <ReportIcon color="error"/>
                  }
                </ListItemIcon>
                <ListItemText>
                  { profilePid
                    ? <Link href={resolvePid(profilePid)}>Profile</Link>
                    : 'Profile not available.'
                  }
                </ListItemText>
              </MenuItem>
              </>)}
            </MenuList>
          </Item>

          <Item sx={{ width: '50%' }} >
            <Stack direction="row" spacing={3}>
              <Avatar sx={{ bgcolor: blue[500] }} variant="rounded">
                <AssignmentIcon />
              </Avatar>
              <Typography variant="h5" gutterBottom> {displayName} </Typography>
            </Stack><br/>
            <Typography variant="subtitle1" gutterBottom sx={{ display: 'block', marginLeft: '10px' }}> {genInfo} </Typography>
            <br/>
            <Box>
            <Details/>
            </Box>
          </Item>
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
