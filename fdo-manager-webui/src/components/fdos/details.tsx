import * as React from 'react'
import { styled } from '@mui/material/styles'
import Table from '@mui/material/Table'
import TableBody from '@mui/material/TableBody'
import TableCell, { tableCellClasses } from '@mui/material/TableCell'
import TableContainer from '@mui/material/TableContainer'
import TableHead from '@mui/material/TableHead'
import TableRow from '@mui/material/TableRow'
import Paper from '@mui/material/Paper'
import Typography from '@mui/material/Typography'
import Link from '@mui/material/Link'

const StyledTableCell = styled(TableCell)(({ theme }) => ({
  [`&.${tableCellClasses.head}`]: {
    backgroundColor: theme.palette.common.black,
    color: theme.palette.common.white
  },
  [`&.${tableCellClasses.body}`]: {
    fontSize: 14,
    backgroundColor: theme.palette.common.white,
    ...theme.applyStyles('dark', {
      backgroundColor: '#262c32'
    })
  }
}))

const StyledTableRow = styled(TableRow)(({ theme }) => ({
  '&:nth-of-type(odd)': { backgroundColor: theme.palette.action.hover },
  // hide last border
  '&:last-child td, &:last-child th': {
    border: 0
  }
}))

function createData (
  category: string,
  classification: string,
  logo: string

) {
  return { category, classification, logo }
}


export default function CustomizedTables ({rows}) {
  return (
      <Table aria-label="simple table" sx={{border: 0}}>
        <TableBody >
          {rows.map((row) => (
            <StyledTableRow key={row.category}>
              <StyledTableCell component="th" scope="row" sx={{ border: 0 }}>
               <Typography  sx={{fontSize: 14}} gutterBottom> {row.category}</Typography>
              </StyledTableCell>
              <StyledTableCell align="left">{row.classification}</StyledTableCell>
              <StyledTableCell align="right" sx={{ maxWidth: 140 }}>{row.logo && <img
          style={{ maxHeight: '35px' }}
          src={row.logo}
          title={row.category}
        />
              }</StyledTableCell>
            </StyledTableRow>
          ))}
        </TableBody>
      </Table>
  )
}
