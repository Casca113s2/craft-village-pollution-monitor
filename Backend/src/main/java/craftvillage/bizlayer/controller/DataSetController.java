package craftvillage.bizlayer.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import craftvillage.ai.DataSetDTO;
import craftvillage.bizlayer.services.DataSetService;
import craftvillage.corelayer.utilities.ConstantParameter;

@RestController
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API + "/dataSet")
public class DataSetController {
  @Autowired
  DataSetService dataSetService;

  @GetMapping("/getAll")
  public List<DataSetDTO> getAllDataSet() {
    return dataSetService.getAllDataSetAndPollution();
  }
}
