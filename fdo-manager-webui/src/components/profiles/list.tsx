import { IResourceComponentsProps } from '@refinedev/core'
import Link from '@mui/material/Link'

import { List, useDataGrid } from '@refinedev/mui'

import {
  DataGrid,
  GridColDef,
  GridValueFormatterParams
} from '@mui/x-data-grid'

import IProfile from '../../interfaces/IProfile'

const columns: Array<GridColDef<IProfile>> = [
  {
    field: 'id',
    headerName: 'Name',
    type: 'string',
    width: 200
  }, {
    field: 'description',
    headerName: 'Description',
    type: 'string',
    minWidth: 200,
    flex: 1,
    valueGetter: (params) => {
      return params?.row?.attributes?.description
    }
  }, {
    field: 'link',
    headerName: 'Profile PID',
    type: 'string',
    width: 300,
    renderCell: (params) => {
      const pid = params?.row.attributes.pid
      return <Link href={'https://hdl.handle.net/' + pid}>{pid}</Link>
    }
  }
]

export const ProfilesList: React.FC<IResourceComponentsProps> = () => {
  const { dataGridProps } = useDataGrid<IProfile>()

  return (
    <List>
      <DataGrid {...dataGridProps} columns={columns} autoHeight />
    </List>
  )
}
