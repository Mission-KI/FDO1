import { useGetToPath, useParsed, useGo } from '@refinedev/core'
import Button from '@mui/material/Button'

export const ShowInfo = () => {
  const { params } = useParsed()
  const go = useGo()

  return <Button onClick={() => { go({ to: { resource: 'info', action: 'show', id: 'asdf', meta: { prefix: 'prefix2', suffix: 'blub' } }, type: 'push' }) }}>
   { 'id(' + params?.id + ')'}
    </Button>
}

export default ShowInfo
