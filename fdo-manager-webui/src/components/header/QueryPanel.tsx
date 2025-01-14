import { useState } from 'react'
import Paper from '@mui/material/Paper'
import InputBase from '@mui/material/InputBase'
import IconButton from '@mui/material/IconButton'
import SearchIcon from '@mui/icons-material/Search'
import FormHelperText from '@mui/material/FormHelperText'
import FormControl from '@mui/material/FormControl'
import { useGo, useNotification } from '@refinedev/core'

export default function QueryPanel () {
  const [pid, setPid] = useState('')
  const [error, setError] = useState<string | boolean>(false)
  const go = useGo()
  const onChange = (e: any) => {
    setPid(e.target.value)
    setError(false)
  }
  const onSubmit = (e: any) => {
    e.preventDefault()
    if (!pid.includes('/')) {
      setError('prefix / suffix')
      return false
    }

    const prefix = pid?.split('/', 1)[0]
    const suffix = pid?.substring(prefix.length + 1)
    go({ to: { resource: 'fdo', action: 'show', id: pid, meta: { prefix, suffix } }, type: 'push' })
  }
  return (
    <FormControl error={!!error}>
    <Paper
      component="form"
      sx={{ p: '2px 4px', display: 'flex', alignItems: 'center', width: 400 }}
      onSubmit={onSubmit}
    >
      <FormHelperText>{error}</FormHelperText>
      <InputBase
        sx={{ flex: 1 }}
        placeholder="Resolve PID"
        inputProps={{ 'aria-label': 'resolve pid' }}
        value={pid}
        onChange={onChange}
      />
      <IconButton onClick={onSubmit} type="button" sx={{ p: '10px' }} aria-label="search">
        <SearchIcon />
      </IconButton>
    </Paper>
    </FormControl>
  )
}
