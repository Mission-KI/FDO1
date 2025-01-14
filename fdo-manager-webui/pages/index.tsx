// import * as React from 'react'
import React, { useContext } from 'react'
import { useRouter } from 'next/router'
import { experimentalStyled as styled } from '@mui/material/styles'
import AppBar from '@mui/material/AppBar'
import Box from '@mui/material/Box'
import Toolbar from '@mui/material/Toolbar'
import Typography from '@mui/material/Typography'
import Paper from '@mui/material/Paper'
import Avatar from '@mui/material/Avatar'
import IconButton from '@mui/material/IconButton'
import DarkModeOutlined from '@mui/icons-material/DarkModeOutlined'
import LightModeOutlined from '@mui/icons-material/LightModeOutlined'
import { ColorModeContext } from '@contexts'
import FormControl from '@mui/material/FormControl'
import MenuItem from '@mui/material/MenuItem'
import Select from '@mui/material/Select'
import Stack from '@mui/material/Stack'
import Link from 'next/link'
import ContentArea from '@components/ContentArea'

const Item = styled(Paper)(({ theme }) => ({
  backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
  ...theme.typography.body2,
  padding: theme.spacing(2),
  textAlign: 'center',
  color: theme.palette.text.secondary
}))

export default function Index () {
  const { mode, setMode } = useContext(ColorModeContext)
  const { locale: currentLocale, locales, pathname, query } = useRouter()

  return (
    <Box sx={{ flexGrow: 1 }}>
      <AppBar position="static">
        <Toolbar>
          <Avatar
              alt="FDO logo graphic"
              src="images/logo-fdo-white.png">
          </Avatar>
          <Typography
            variant="h6"
            noWrap
            component="div"
            marginLeft={2}
            sx={{ flexGrow: 1, display: { xs: 'none', sm: 'block' } }}>
            FDO MANAGER
          </Typography>
          { /*
          <Stack
            direction="row"
            width="80%"
            justifyContent="flex-end"
            alignItems="center"
            gap="14px">
            <FormControl sx={{ minWidth: 64 }}>
              <Select
                disableUnderline
                defaultValue={currentLocale}
                inputProps={{ 'aria-label': 'Without label' }}
                variant="standard"
                sx={{
                  color: 'inherit',
                  '& .MuiSvgIcon-root': { color: 'inherit' },
                  '& .MuiStack-root > .MuiTypography-root': { display: { xs: 'none', sm: 'block' } }
                }} >
                    {[...(locales ?? [])].sort().map((lang: string) => (
                      // @ts-expect-error
                    <MenuItem
                      component={Link}
                      href={{ pathname, query }}
                      locale={lang}
                      selected={currentLocale === lang}
                      key={lang}
                      defaultValue={lang}
                      value={lang} >
                        <Typography>
                         {lang === 'en' ? 'English' : 'German'}
                        </Typography>
                    </MenuItem>
                    ))}
              </Select>
            </FormControl>
          </Stack>
          */}
          <Stack marginLeft={2}>
            <IconButton
              color="inherit"
              onClick={() => {
                setMode()
              }} >
              {mode === 'dark' ? <LightModeOutlined /> : <DarkModeOutlined />}
            </IconButton>
          </Stack>
        </Toolbar>
      </AppBar>
     <ContentArea/>
    </Box>
  )
}

Index.noLayout = true
