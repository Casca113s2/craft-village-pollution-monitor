package craftvillage.ai;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import craftvillage.bizlayer.services.DataSetService;
import craftvillage.datalayer.repositories.VillageRepository;

@Service
public class TrainingService {
  @Value("${AI.URL}")
  private String base;
  @Autowired
  DataSetService dataSetService;

  @Autowired
  VillageRepository villageRepository;

  public String detectPollution(int villageId) {
    Map<String, List<Question>> bodyMap = new HashMap<String, List<Question>>();
    bodyMap.put("data", dataSetService.getDataSetByVillage(villageId));
    WebClient webClient = WebClient.create(base);
    String responseSpec = webClient.post().uri("/predict").body(BodyInserters.fromValue(bodyMap))
        .exchange().flatMap(clientResponse -> {
          if (clientResponse.statusCode().is5xxServerError()) {
            clientResponse.body((clientHttpResponse, context) -> {
              return clientHttpResponse.getBody();
            });
            return clientResponse.bodyToMono(String.class);
          } else
            return clientResponse.bodyToMono(String.class);
        }).block();
    return responseSpec;
  }
}
