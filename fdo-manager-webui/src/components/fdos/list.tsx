import { useTranslate, IResourceComponentsProps } from '@refinedev/core'
import Link from '@mui/material/Link'
import Typography from '@mui/material/Typography'

import { List, useDataGrid } from '@refinedev/mui'

import {
  DataGrid,
  GridColDef,
  GridValueFormatterParams
} from '@mui/x-data-grid'

import { OperationsLogRecord } from '../../api/api'

const columns: Array<GridColDef<OperationsLogRecord>> = [
  {
    field: 'operation',
    headerName: 'Operation',
    type: 'string',
    width: 120
  },
  {
    field: 'id',
    headerName: 'FDO',
    minWidth: 200,
    flex: 1,
    type: 'string',
    renderCell: (params): any => {
      return <Link href={`/fdo/show/${params.id}`}>{params.id}</Link>
    }
  }, {
    field: 'timestamp',
    headerName: 'Datetime',
    type: 'string',
    width: 240
  }, {
    field: 'repository',
    headerName: 'Repository',
    type: 'string',
    width: 180
  }
]

export const LoggingList: React.FC<IResourceComponentsProps> = () => {
  const t = useTranslate()
  const { dataGridProps } = useDataGrid<OperationsLogRecord>({
    resource: 'fdo'
  })

  const rows = dataGridProps.rows.map((record: OperationsLogRecord, index) => {
    return { id: record?.attributes?.fdo?.pid, operation: record?.attributes?.operation, timestamp: record?.attributes?.timestamp, repository: record?.attributes?.repositories?.fdo }
  })

  return (
    <List title={<Typography variant="h5">{t('pages.fdo.list.title', 'FDO Manager Log')}</Typography>}>
      <DataGrid {...dataGridProps} rows={rows} columns={columns} autoHeight />
    </List>
  )
}
