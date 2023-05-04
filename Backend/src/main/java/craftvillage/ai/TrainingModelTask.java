package craftvillage.ai;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class TrainingModelTask {
  private static Logger logger = LoggerFactory.getLogger(TrainingModelTask.class);
  @Autowired
  TrainingService trainingService;

  @Scheduled(cron = "${task.training.cron}", zone = "${timeZone}")
  public void scheduleTrainingTask() {
    logger.info("Training task run...");
    if (trainingService.trainData()) {
      logger.info("Training task completed!");
    } else {
      logger.error("Training task fail!");
    }
  }

  @Scheduled(cron = "${task.detecting.cron}", zone = "${timeZone}")
  public void scheduleDetectingTask() {
    logger.info("Detecting task run...");
    if (trainingService.detectPollution()) {
      logger.info("Detecting task completed!");
    } else {
      logger.error("Detecting task fail!");
    }
  }
}
