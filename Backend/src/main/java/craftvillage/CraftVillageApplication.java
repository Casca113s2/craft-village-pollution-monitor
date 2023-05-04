package craftvillage;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.scheduling.annotation.EnableScheduling;
import craftvillage.datalayer.model.FileStorageProperties;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@SpringBootApplication
@EnableConfigurationProperties({FileStorageProperties.class})
@EnableSwagger2
@EnableScheduling
public class CraftVillageApplication {

  public static void main(String[] args) {
    SpringApplication.run(CraftVillageApplication.class, args);
  }
}
