package com.indiscale.fdo.manager.service.hello;

import com.indiscale.fdo.manager.service.BaseController;
import com.indiscale.fdo.manager.service.api.model.GetInfo200Response;
import com.indiscale.fdo.manager.service.api.model.Info;
import com.indiscale.fdo.manager.service.api.operation.InfoApi;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin(origins = {"${react-dev-server}"})
public class InfoImpl extends BaseController implements InfoApi {

  @Value("${fdo.service.version}")
  private String fdoServiceVersion;

  @Value("${fdo.sdk.version}")
  private String fdoSdkVersion;

  @Override
  public ResponseEntity<GetInfo200Response> getInfo() {
    Info data = new Info().fdoServiceVersion(fdoServiceVersion).fdoSdkVersion(fdoSdkVersion);
    return ResponseEntity.ok(new GetInfo200Response(data));
  }
}
