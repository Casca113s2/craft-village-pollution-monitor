package craftvillage.ai;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import craftvillage.bizlayer.services.DataSetService;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.repositories.VillageRepository;

@Service
public class TrainingService {
  private static String base = "";
  @Autowired
  DataSetService dataSetService;

  @Autowired
  VillageRepository villageRepository;

  public boolean trainData() {
    Map<String, List<DataSetDTO>> bodyMap = new HashMap<String, List<DataSetDTO>>();
    bodyMap.put("data", dataSetService.getAllDataSetAndPollution());
    WebClient webClient = WebClient.create(base);
    boolean responseSpec = webClient.post().uri("").body(BodyInserters.fromValue(bodyMap))
        .exchange().flatMap(clientResponse -> {
          if (clientResponse.statusCode().is5xxServerError()) {
            clientResponse.body((clientHttpResponse, context) -> {
              return clientHttpResponse.getBody();
            });
            return clientResponse.bodyToMono(Boolean.class);
          } else
            return clientResponse.bodyToMono(Boolean.class);
        }).block();
    return responseSpec;
  }

  public boolean detectPollution() {
    Map<String, List<DetectedDataDTO>> bodyMap = new HashMap<String, List<DetectedDataDTO>>();
    bodyMap.put("data", dataSetService.getAllDataSetAndVillageId());
    WebClient webClient = WebClient.create(base);
    DetectedPollutionDTO[] responseSpec = webClient.post().uri("")
        .body(BodyInserters.fromValue(bodyMap)).exchange().flatMap(clientResponse -> {
          if (clientResponse.statusCode().is5xxServerError()) {
            clientResponse.body((clientHttpResponse, context) -> {
              return clientHttpResponse.getBody();
            });
            return clientResponse.bodyToMono(DetectedPollutionDTO[].class);
          } else
            return clientResponse.bodyToMono(DetectedPollutionDTO[].class);
        }).block();
    if (responseSpec.length == 0) {
      return false;
    }
    for (DetectedPollutionDTO detectedPollutionDTO : responseSpec) {
      Village village = villageRepository.getOne(detectedPollutionDTO.getVillageId());
      village.setState(detectedPollutionDTO.getState());
      villageRepository.save(village);
    }
    return true;
  }
}
