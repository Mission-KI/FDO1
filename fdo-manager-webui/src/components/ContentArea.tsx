import * as React from 'react'
import { styled } from '@mui/material/styles'
import Grid from '@mui/material/Grid'
import Paper from '@mui/material/Paper'
import Box from '@mui/material/Box'
import QueryPanel from './header/QueryPanel'
import Content from '@components/Content'
import Typography from '@mui/material/Typography'
import Divider from '@mui/material/Divider'
import Button from '@mui/material/Button'
import FDOImage from '@components/FDOImage'
import Stack from '@mui/material/Stack'
import Evebs from '@components/Evebs'
import Link from '@mui/material/Link'
import { FDO_COMMUNITY_MD_PROFILE_AAS as AAS, HANDLE_SYSTEM_BASE_URI as HS_BASE_URI, HANDLE_SYSTEM_DOWNLOAD_PROXY as HS_PROXY, CORDRA_HANDLE as CORDRA, FDO_COMMUNITY_TYPE_EVEBS as EVEBS } from '../constants'

const Item = styled(Paper)(({ theme }) => ({
  backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
  ...theme.typography.body2,
  padding: theme.spacing(2),
  textAlign: 'center',
  color: theme.palette.text.secondary
}))

export default function RowAndColumnSpacing () {
  const leftShowCase = process.env.NEXT_PUBLIC_SHOWCASE_LEFT_PID
  const leftShowCaseMD = process.env.NEXT_PUBLIC_SHOWCASE_LEFT_MDPID
  const rightShowCase = process.env.NEXT_PUBLIC_SHOWCASE_RIGHT_PID
  const rightShowCaseMD = process.env.NEXT_PUBLIC_SHOWCASE_RIGHT_MDPID
  return (
    <Box alignItems="center">
      <Grid container spacing={2} columns={10} justifyContent="center" alignItems="center" marginTop={2}>
        <Grid item xs={6}>
        <Item>
            <FDOImage/>
          <Typography variant="h3" gutterBottom marginTop={2}>
              Welcome to the FDO Manager
          </Typography><br/>
          <Stack direction="row" spacing={2} justifyContent="center">
              <Button variant="contained" href="/fdo">Browse latest FDOs</Button><QueryPanel/>
              </Stack>
          </Item>
        </Grid>

      </Grid>

      { (leftShowCase || rightShowCase) &&
      <Grid container spacing={2} columns={20} justifyContent="center" alignItems="center" marginTop={2}>
        <Grid item xs={6}>
            { leftShowCase &&
              <Evebs typePid={EVEBS}
                     metadataPid={leftShowCaseMD}
                     title="Showcase: An Asset Adminstration Shell(AAS) FDO"
                     subtitle={<Link href={"/fdo/show/" + leftShowCase}>Show {leftShowCase}</Link>} />
            }
         </Grid>
         <Grid item xs={6}>
            { rightShowCase &&
              <Evebs typePid={EVEBS}
                     metadataPid={rightShowCaseMD}
                     title="Showcase: An FDO hosted in an Eclipse Dataspace Components (EDC) Dataspace"
                     subtitle={<Link href={"/fdo/show/" + rightShowCase}>Show {rightShowCase}</Link>} />
            }
         </Grid>
       </Grid>
       }

    </Box>
  )
}
