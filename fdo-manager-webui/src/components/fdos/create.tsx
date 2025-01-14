import { useState, useEffect } from 'react'
import { useGo, IResourceComponentsProps, useList, HttpError, useGetIdentity } from '@refinedev/core'
import { Create } from '@refinedev/mui'
import LoadingButton from '@mui/lab/LoadingButton'
import SaveIcon from '@mui/icons-material/Save'
import { useTheme, styled } from '@mui/material/styles'

import Skeleton from '@mui/material/Skeleton'
import Stack from '@mui/material/Stack'
import Box from '@mui/material/Box'
import TextField from '@mui/material/TextField'
import InputLabel from '@mui/material/InputLabel'
import Typography from '@mui/material/Typography'
import Autocomplete from '@mui/material/Autocomplete'
import Button from '@mui/material/Button'
import Step from '@mui/material/Step'
import StepButton from '@mui/material/StepButton'
import Stepper from '@mui/material/Stepper'
import MenuItem from '@mui/material/MenuItem'
import Select, { SelectChangeEvent } from '@mui/material/Select'
import FormHelperText from '@mui/material/FormHelperText'
import FormControl from '@mui/material/FormControl'
import useMediaQuery from '@mui/material/useMediaQuery'
import CloudUploadIcon from '@mui/icons-material/CloudUpload'
import CircularProgress from '@mui/material/CircularProgress'

import { useStepsForm } from '@refinedev/react-hook-form'

import { Controller } from 'react-hook-form'

import { IRepository, IProfile } from '../../interfaces'
import { RepositoriesList } from '../repositories'
import { useAccessToken } from '../../utils'

const stepTitles = ['Profile & Repository', 'Metadata', 'Data']

const StepRepository: React.FC<any> = ({ control, register, errors }) => {
  const repositoryList = useList<IRepository, HttpError>({
    resource: 'repositories'
  })
  const profileList = useList<IProfile, HttpError>({
    resource: 'profiles'
  })
  if (profileList.isLoading && repositoryList.isLoading) {
    return <CircularProgress/>
  }

  return (
    <>
    <FormControl fullWidth>
      <InputLabel id="profile-select-label">Profile</InputLabel>
        <Controller control={control}
          rules={{ required: 'This field is required' }}
          name="profile"
          render={({ field }) => {
            return (
              profileList.isLoading
                ? <Skeleton><Select></Select></Skeleton>
                : <Select
                {...field}
                error={!!errors.profile}
                labelId="profile-select-label"
                id="profile-select"
                label="Profile"
              >
                { profileList.data?.data?.map((item, idx) => <MenuItem key={idx} value={item.id}>{item.id}</MenuItem>)}
              </Select>
            )
          }}/>
      <FormHelperText>{errors.profile?.message}</FormHelperText>
    </FormControl>
    <FormControl fullWidth>
      <InputLabel id="repository-select-label">Repository</InputLabel>
        <Controller control={control}
          rules={{ required: 'This field is required' }}
          name="repository"
          render={({ field }) => {
            return (
              repositoryList.isLoading
                ? <Skeleton><Select></Select></Skeleton>
                : <Select
                {...field}
                error={!!errors.repository}
                labelId="repository-select-label"
                id="repository-select"
                label="Repository"
              >
                { repositoryList.data?.data?.map((item, idx) => <MenuItem key={idx} value={item.id}>{item.id}</MenuItem>)}
              </Select>
            )
          }}/>
      <FormHelperText>{errors.repository?.message}</FormHelperText>
    </FormControl>
    </>
  )
}

/*
interface IRepositoryFormValues {
  fdo: string,
  data: string,
  metadata: string
}
*/

const VisuallyHiddenInput = styled('input')({
  clip: 'rect(0 0 0 0)',
  clipPath: 'inset(50%)',
  height: 1,
  overflow: 'hidden',
  position: 'absolute',
  bottom: 0,
  left: 0,
  whiteSpace: 'nowrap',
  width: 1
})

const StepMetadata: React.FC<any> = ({ control, register, errors, setError }) => {
  return <FileUpload register={register} errors={errors} name="fdo_metadata" label="Upload metadata file" setError={setError}/>
}

const FileUpload: React.FC<any> = ({ register, errors, name, label, setError }) => {
  const validate = { lessThan10MB: (files: any) => files[0]?.size < 10000000 || 'Max 10MB' }
  const accept = 'max 10MB'
  const [files, setFiles] = useState<any>([])
  const inputProps = register(name, {
    required: 'This field is required.',
    validate
  })

  const onChange = (e: any) => {
    setFiles(e.target?.files)
    inputProps.onChange(e)
  }

  return (
    <Stack>
    {accept && <FormHelperText>Accepted: {accept}</FormHelperText>}
    <FormControl error={!!errors[name]} fullWidth>
      <span>
          <Button
            component="label"
            role={undefined}
            variant="contained"
            tabIndex={-1}
            startIcon={<CloudUploadIcon />}
          >
          {label}
        <VisuallyHiddenInput {...inputProps} accept={accept} onChange={onChange} type="file"/>
        </Button>
      </span>
      <FormHelperText>{files.length > 0 && files[0].name }</FormHelperText>
      <FormHelperText>{errors[name]?.message}</FormHelperText>
    </FormControl>
    </Stack>
  )
}

const StepData: React.FC<any> = ({ register, errors }) => {
  return <FileUpload register={register} errors={errors} name="fdo_data" label="Upload data file"/>
}

const showNewFdo = (go, pid) => {
    const prefix = pid.split('/', 1)[0]
    const suffix = pid.substring(prefix.length + 1)
    setTimeout(() => go({ to: { resource: 'fdo', action: 'show', id: pid, meta: { prefix, suffix } }, type: 'replace' }), 300);
}

export const FdoCreate: React.FC<IResourceComponentsProps> = () => {
  const go = useGo()
  const accessToken = useAccessToken()

  const meta = {
    headers: { Authorization: `Bearer ${accessToken}` }
  }

  const formRet = useStepsForm<any, HttpError, any>({ defaultValues: { repository: '', profile: '' }, refineCoreProps: { meta: meta } })
  const {
    setError,
    saveButtonProps,
    refineCore: {
      formLoading, onFinish,
      mutationResult: { data, error, isLoading }
    },
    register,
    handleSubmit,
    control,
    formState: { errors },
    steps: { currentStep, gotoStep }
  } = formRet

  if (data?.data?.pid) {
    showNewFdo(go, data.data.pid)
  }

  const onSubmit = (data: any) => {
    onFinish([{ fdo: data.repository }, data.fdo_data[0], data.fdo_metadata[0]])
  }
  const theme = useTheme()
  const isSmallOrLess = useMediaQuery(theme.breakpoints.down('sm'))

  const renderFormByStep = (step: number) => {
    switch (step) {
      case 0:
        return (
          <StepRepository control={control} register={register} errors={errors} setError={setError}/>
        )
      case 1:
        return (
          <StepMetadata control={control} register={register} errors={errors} setError={setError}/>
        )
      case 2:
        return (
          <StepData control={control} register={register} errors={errors} setError={setError}/>
        )
    }
  }

  return (
    <Create
      title={<Typography variant="h5">Create FDO</Typography>}
      isLoading={formLoading}
      saveButtonProps={saveButtonProps}
      footerButtons={
        <>
          {currentStep > 0 && (
            <Button
              onClick={() => {
                gotoStep(currentStep - 1)
              }}
            >
              Previous
            </Button>
          )}
          {currentStep < stepTitles.length - 1 && (
            <Button
              onClick={() => {
                gotoStep(currentStep + 1)
              }}
            >
              Next
            </Button>
          )}
          {currentStep === stepTitles.length - 1 && (
            <LoadingButton
              loading={isLoading}
              loadingPosition="start"
              startIcon={<SaveIcon />}
              variant="outlined"
              onClick={handleSubmit(onSubmit)}
              >
              Save
            </LoadingButton>
          )}
        </>
      }
    >
      <Box
        component="form"
        sx={{ display: 'flex', flexDirection: 'column' }}
        autoComplete="off"
      >
        <Stack spacing={4}>
        <Stepper
          nonLinear
          activeStep={currentStep}
          orientation={isSmallOrLess ? 'vertical' : 'horizontal'}
        >
          {stepTitles.map((label, index) => (
            <Step key={label}>
              <StepButton onClick={() => { gotoStep(index) }}>{label}</StepButton>
            </Step>
          ))}
        </Stepper>
        {renderFormByStep(currentStep)}
        </Stack>
      </Box>
    </Create>
  )
}
