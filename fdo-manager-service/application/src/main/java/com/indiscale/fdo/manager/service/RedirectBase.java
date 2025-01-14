package com.indiscale.fdo.manager.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/")
public class RedirectBase {

  @Value("${springdoc.swagger-ui.path}")
  private String swaggerUiPath;

  @GetMapping("/")
  public ModelAndView redirectToSwaggerUi(ModelMap model) {
    return new ModelAndView("forward:" + swaggerUiPath, model);
  }
}
