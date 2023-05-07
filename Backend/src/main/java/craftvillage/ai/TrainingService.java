package craftvillage.ai;

import java.io.File;
import java.io.FileWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import com.google.gson.Gson;
import craftvillage.bizlayer.services.DataSetService;
import craftvillage.datalayer.repositories.VillageRepository;
import craftvillage.datalayer.services.MailService;

@Service
public class TrainingService {
  @Value("${host.ai.url}")
  private static String base;
  @Value("${spring.mail.username}")
  private static String systemMailAddress;
  @Autowired
  DataSetService dataSetService;
  @Autowired
  MailService mailService;
  @Autowired
  private JavaMailSender javaMailSender;

  @Autowired
  VillageRepository villageRepository;

  public boolean sendTrainingData() {
    try {
      File file = new File("logs/training_data.json");

      // Printing the path of the directory where the file
      // is created
      Writer writer = new FileWriter(file.getAbsolutePath());
      Gson gson = new Gson();
      gson.toJson(dataSetService.getAllDataSetAndPollution(), writer);
      writer.close();
      MimeMessage message = javaMailSender.createMimeMessage();
      MimeMessageHelper helper = new MimeMessageHelper(message, true);
      helper.setTo(systemMailAddress);
      FileSystemResource attachedFile = new FileSystemResource(file);
      helper.setText("File below!");
      helper.addAttachment("training_data.json", attachedFile);
      helper.setSubject("Training Data");
      javaMailSender.send(message);
      // Deleting the file while exiting the program
      file.deleteOnExit();
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }

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
