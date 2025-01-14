import * as React from 'react'
import Card from '@mui/material/Card'
import CardActions from '@mui/material/CardActions'
import CardContent from '@mui/material/CardContent'
import CardMedia from '@mui/material/CardMedia'
import Button from '@mui/material/Button'
import Typography from '@mui/material/Typography'
import Link from '@mui/material/Link'
import Box from '@mui/material/Box'

export default function GWDGCard () {
  return (
    <Card sx={{ backgroundColor: 'white', maxWidth: 480 }}>
      <CardContent>
        <Box sx={{ width: 300 }}>
        <img
          style={{ width: '100%' }}
          src="/images/gwdg_logo.min.svg"
          title="GWDG"
        />
        </Box>
        <Typography variant="body2" color="text.secondary">
          <Link href="https://www.gwdg.de">www.gwdg.de</Link>
        </Typography>
      </CardContent>
    </Card>
  )
}
