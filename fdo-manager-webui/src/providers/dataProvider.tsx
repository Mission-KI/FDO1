import { DataProvider, useOne } from '@refinedev/core'
import dataProvider from '@refinedev/simple-rest'
import { Configuration, ProfilesApi, RepositoriesApi, FDOsApi, InfoApi, LoggingApi, GetInfo200Response, ListRepositories200Response } from '../api'
import axios from 'axios'

const getNewlyCreated = async (newLocation: string) => {
  const response = await axios.get(newLocation)
  if (response.data.data) {
    return response.data.data;
  }
  return response.data;
}

const apiDataProvider = (apiUrl: string): DataProvider => {
  const config: Configuration = new Configuration({ basePath: apiUrl })
  const apiResources: any = {
    info: new InfoApi(config),
    fdo: new FDOsApi(config),
    profiles: new ProfilesApi(config),
    repositories: new RepositoriesApi(config),
    logging: new LoggingApi(config)
  }

  const apiOperations: any = {
    profiles: {
      list: apiResources.profiles.listProfiles,
      get: apiResources.profiles.getProfile
    },
    repositories: {
      list: apiResources.repositories.listRepositories,
      get: apiResources.repositories.getRepository
    },
    info: {
      get: apiResources.info.getInfo
    },
    fdo: {
      list: apiResources.logging.listLogEvents,
      get: apiResources.fdo.resolvePID,
      create: apiResources.fdo.createFDO
    }
  }

  const callOperation = async (resource: string, operation: string, kwargs: any) => {
    const resourceObj: any = apiResources[resource] || apiResources.default
    const func: any = apiOperations[resource][operation]
    const headers = kwargs?.meta?.headers
    if (func && (operation === 'get' || operation === 'list')) {
      if (kwargs?.id) {
        return (await func.apply(resourceObj, [kwargs.id])).data
      } else {
        return (await func.apply(resourceObj)).data
      }
    } else if (func && operation === 'create') {
      return await func.apply(resourceObj, kwargs.variables.concat({ headers }))
    }
    throw new Error('Not implemented')
  }

  const _fallBack = dataProvider(apiUrl)

  return {
    custom: async ({
      url,
      method,
      filters,
      sorters,
      payload,
      query,
      headers,
      meta
    }) => {
      if (method === 'get') {
        return { data: (await getNewlyCreated(url)) }
      } else {
        throw new Error('Not implemented')
      }
    },

    getOne: async ({ resource, id, meta }) => {
      const data = await callOperation(resource, 'get', { id, meta })
      return { data: data.data }
    },
    create: async ({ resource, variables, meta }) => {
      const response = await callOperation(resource, 'create', { variables, meta })
      if (response.status === 201) {
        const newLocation = response.headers.location
        const newData = await getNewlyCreated(newLocation)
        return { data: newData }
      } else {
        throw new Error('Create with anything else than 201 not implemented.')
      }
    },
    update: async () => {
      throw new Error('Not implemented')
    },
    deleteOne: async () => {
      throw new Error('Not implemented')
    },
    getList: async ({ resource, pagination, sorters, filters, meta }) => {
      const data = (await callOperation(resource, 'list', { pagination, sorters, filters, meta })).data
      return { data, total: data?.length || 0 }
    },
    getApiUrl: () => apiUrl
  }
}

export default apiDataProvider
