export interface IProfileAttributes {
  pid: string
  description: string
}

export interface IProfile {
  id: string
  attributes: IProfileAttributes
}

export default IProfile
