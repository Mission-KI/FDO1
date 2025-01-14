package com.indiscale.fdo.manager.service.hello;

import com.indiscale.fdo.manager.service.api.model.Hello;
import com.indiscale.fdo.manager.service.api.operation.HelloApi;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin(origins = {"${react-dev-server}"})
public class HelloImpl implements HelloApi {
  @Override
  public ResponseEntity<Hello> hello() {
    Hello hello = new Hello();
    hello.message("Hello from FDO Manager Service!");
    return ResponseEntity.ok(hello);
  }
}
