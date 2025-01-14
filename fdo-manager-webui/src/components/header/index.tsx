import { ColorModeContext } from '@contexts'
import DarkModeOutlined from '@mui/icons-material/DarkModeOutlined'
import LightModeOutlined from '@mui/icons-material/LightModeOutlined'
import AppBar from '@mui/material/AppBar'
import FormControl from '@mui/material/FormControl'
import IconButton from '@mui/material/IconButton'
import MenuItem from '@mui/material/MenuItem'
import Select from '@mui/material/Select'
import Stack from '@mui/material/Stack'
import Toolbar from '@mui/material/Toolbar'
import Typography from '@mui/material/Typography'
import { HamburgerMenu, RefineThemedLayoutV2HeaderProps } from '@refinedev/mui'
import Alert from '@mui/material/Alert'
import Link from 'next/link'
import { useRouter } from 'next/router'
import React, { useContext } from 'react'
import UserComponent from './UserComponent'
import QueryPanel from './QueryPanel'

export const Header: React.FC<RefineThemedLayoutV2HeaderProps> = ({
  sticky = true
}) => {
  const { mode, setMode } = useContext(ColorModeContext)
  const { locale: currentLocale, locales, pathname, query } = useRouter()

  return (
    <AppBar position={sticky ? 'sticky' : 'relative'}>
      <Toolbar>
        <Stack direction="row" width="100%" alignItems="center">
          <HamburgerMenu />
          <Alert variant="filled" sx={{ width: 200 }} severity="error">
          This is a demo!
          </Alert>
          <Stack
            direction="row"
            width="100%"
            justifyContent="flex-end"
            alignItems="center"
            gap="16px"
          >
            <QueryPanel/>
            { /*
            <FormControl sx={{ minWidth: 64 }}>
              <Select
                disableUnderline
                defaultValue={currentLocale}
                inputProps={{ 'aria-label': 'Without label' }}
                variant="standard"
                sx={{
                  color: 'inherit',
                  '& .MuiSvgIcon-root': {
                    color: 'inherit'
                  },
                  '& .MuiStack-root > .MuiTypography-root': {
                    display: {
                      xs: 'none',
                      sm: 'block'
                    }
                  }
                }}
              >
                {[...(locales ?? [])].sort().map((lang: string) => (
                  // @ts-expect-error
                  <MenuItem
                    component={Link}
                    href={{ pathname, query }}
                    locale={lang}
                    selected={currentLocale === lang}
                    key={lang}
                    defaultValue={lang}
                    value={lang}
                  >
                    <Stack
                      direction="row"
                      alignItems="center"
                      justifyContent="center"
                    >
                      <Typography>
                        {lang === 'en' ? 'English' : 'German'}
                      </Typography>
                    </Stack>
                  </MenuItem>
                ))}
              </Select>
            </FormControl>
            */}

            <IconButton
              color="inherit"
              onClick={() => {
                setMode()
              }}
            >
              {mode === 'dark' ? <LightModeOutlined /> : <DarkModeOutlined />}
            </IconButton>

            <UserComponent/>
          </Stack>
        </Stack>
      </Toolbar>
    </AppBar>
  )
}
