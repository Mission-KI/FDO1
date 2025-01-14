import React, { useContext } from 'react'
import Button from '@mui/material/Button'
import Menu from '@mui/material/Menu'
import MenuItem from '@mui/material/MenuItem'
import Stack from '@mui/material/Stack'
import Typography from '@mui/material/Typography'
import Avatar from '@mui/material/Avatar'
import { useGetIdentity, useLogout, useLogin, useTranslate } from '@refinedev/core'
import { ColorModeContext } from "@contexts"

interface IUser {
  name: string
  avatar: string
}

const Login = () => {
  const t = useTranslate()
  const { mutate: login } = useLogin()
  return (
        <Button
          style={{ width: '140px' }}
          // size="large"
          variant="contained"
          onClick={() => { login({}) }}
        >
          {t('pages.login.signin', 'Sign in')}
        </Button>
  )
}

const UserMenu = ({ user }: any) => {
  const { mode } = useContext(ColorModeContext);
  const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null)
  const open = Boolean(anchorEl)
  const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    setAnchorEl(event.currentTarget)
  }
  const handleClose = () => {
    setAnchorEl(null)
  }
  const { mutate: logout } = useLogout()

  return (
    <>
      <Stack
                direction="row"
                gap="16px"
                alignItems="center"
                justifyContent="center"
              >
        {user?.name && (
          <Button
            id="user-button"
            aria-controls={open ? 'user-menu' : undefined}
            aria-haspopup="true"
            aria-expanded={open ? 'true' : undefined}
            sx={{ padding: '0' }}
            onClick={handleClick}
          >
                  <Typography
                    sx={{
                      display: {
                        xs: 'none',
                        sm: 'inline-block'
                      }
                    }}
                    variant="subtitle2"
                    color={mode === "light" && "white" }
                  >
                    {user?.name}
                  </Typography>
          </Button>
        )}
        <Avatar src={user?.avatar} alt={user?.name} />
      </Stack>
      <Menu
        id="user-menu"
        anchorEl={anchorEl}
        open={open}
        onClose={handleClose}
        MenuListProps={{
          'aria-labelledby': 'user-button'
        }}
      >
        {/* <MenuItem onClick={handleClose}>Profile</MenuItem> */}
        {/* <MenuItem onClick={handleClose}>My account</MenuItem> */}
        <MenuItem onClick={() => { logout() }}>Logout</MenuItem>
      </Menu>
    </>
  )
}

export default function UserComponent () {
  const { data, isError, error } = useGetIdentity<IUser>();
  // console.log("UserComponent", data, isError, error);

  return (!isError && data?.name ? <UserMenu user={data}/> : <Login/>)
}
