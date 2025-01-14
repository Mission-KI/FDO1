import React, { useEffect, useState } from 'react'
import { useGo, useResource, useRouterType, useNavigation, useTranslate } from '@refinedev/core'

import Stack from '@mui/material/Stack'
import Button from '@mui/material/Button'
import Tooltip from '@mui/material/Tooltip'
import Typography from '@mui/material/Typography'
import Grid from '@mui/material/Grid'

import Info from '@mui/icons-material/Info'

export const ErrorComponent: React.FC<any> = ({ status = 404, back = undefined, message }) => {
  // const [errorMessage, setErrorMessage] = useState<string>();
  const { push } = useNavigation()
  const go = useGo()
  const routerType = useRouterType()

  // const { resource, action } = useResource();

  const translate = useTranslate()
  const showErrorMessage = message || translate(
    'pages.error.404',
    'Sorry, the page you visited does not exist.'
  )

  /*
    useEffect(() => {
        if (resource && action) {
            setErrorMessage(
                translate(
                    "pages.error.info",
                    {
                        action,
                        resource: resource?.name,
                    },
                    `You may have forgotten to add the "${action}" component to "${resource?.name}" resource.`,
                ),
            );
        }
    }, [action, resource]);
    */

  return (
        <Grid
            display="flex"
            justifyContent="center"
            alignItems="center"
            mt={20}
        >
            <Grid
                container
                direction="column"
                display="flex"
                alignItems="center"
            >
                <Typography variant="h1">{status}</Typography>
                <Stack direction="row" spacing="2">
                    <Typography>
                      { showErrorMessage }
                    </Typography>

                    {/*
                    {errorMessage && (
                        <Tooltip title={errorMessage}>
                            <Info data-testid="error-component-tooltip" />
                        </Tooltip>
                    )}
                    */}
                </Stack>
                { back &&
                  <Button
                      onClick={() => {
                        if (routerType === 'legacy') {
                          push(back)
                        } else {
                          go({ to: back })
                        }
                      }}
                  >
                      {translate('pages.error.backHome', 'Back Home')}
                  </Button>
                }
            </Grid>
        </Grid>
  )
}
