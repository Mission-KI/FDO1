import * as React from 'react'
import Box from '@mui/material/Box'
import Typography from '@mui/material/Typography'

export default function Types () {
  return (
    <Box sx={{ width: '100%', maxWidth: 500 }}>

      <Typography variant="subtitle1" gutterBottom>
        Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quos
        blanditiis tenetur
      </Typography>

      <Typography variant="body1" gutterBottom>
      Dies ist ein spannendes FDO.
      </Typography>

      <Typography variant="button" display="block" gutterBottom>
        button text
      </Typography>
      <Typography variant="caption" display="block" gutterBottom>
        caption text
      </Typography>
      <Typography variant="overline" display="block" gutterBottom>
        overline text
      </Typography>
    </Box>
  )
}
