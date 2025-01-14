import { IResourceComponentsProps } from '@refinedev/core'
import Link from '@mui/material/Link'

import { List, useDataGrid } from '@refinedev/mui'

import {
  DataGrid,
  GridColDef,
  GridValueFormatterParams
} from '@mui/x-data-grid'

import IRepository from '../../interfaces/IRepository'

const columns: Array<GridColDef<IRepository>> = [
  {
    field: 'id',
    headerName: 'ID',
    type: 'string',
    width: 200,
    renderCell: (params) => {
      return params.value
    }
  }, {
    field: 'description',
    headerName: 'Description',
    type: 'string',
    minWidth: 250,
    flex: 1,
    valueGetter: (params): string => {
      return params?.row?.attributes?.description
    }
  }, {
    field: 'maintainer',
    headerName: 'Maintainer',
    type: 'string',
    minWidth: 200,
    flex: 1,
    valueGetter: (params): string => {
      return params?.row?.attributes?.maintainer
    }
  }
]

export const RepositoriesList: React.FC<IResourceComponentsProps> = () => {
  const { dataGridProps } = useDataGrid<IRepository>()

  return (
    <List>
      <DataGrid {...dataGridProps} columns={columns} autoHeight />
    </List>
  )
}
