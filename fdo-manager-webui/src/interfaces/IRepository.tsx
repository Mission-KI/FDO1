export interface IRepositoryAttributes {
  description: string
  maintainer: string
  attributes: any
}

export interface IRepository {
  id: string
  attributes: IRepositoryAttributes
}

export default IRepository
