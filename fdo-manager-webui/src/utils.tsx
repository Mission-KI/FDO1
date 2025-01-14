import { useLogout, useGetIdentity, useNotification } from '@refinedev/core'

const doLogout = (logout: Function, notify: (Function | undefined)) => {
  logout()
  notify?.({
    type: 'error',
    message: 'Logout',
    description: 'You have been logged out.'
  })
}

export const useAccessToken: any = () => {
  const identity = useGetIdentity<any>()
  const { mutate: logout } = useLogout()
  const { open } = useNotification()

  const data = identity?.data?.data

  if (data?.error) {
    doLogout(logout, open)
    return null
  }

  return data?.access_token
}
