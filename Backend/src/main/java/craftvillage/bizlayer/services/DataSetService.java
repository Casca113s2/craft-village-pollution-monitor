package craftvillage.bizlayer.services;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import craftvillage.ai.Answer;
import craftvillage.ai.DataSet;
import craftvillage.ai.DataSetDTO;
import craftvillage.ai.Question;
import craftvillage.datalayer.repositories.DataSetRepository;
import craftvillage.datalayer.repositories.SrSurveyQuestionRepository;
import craftvillage.datalayer.repositories.VillageRepository;

@Service
public class DataSetService {
  @Autowired
  DataSetRepository dataSetRepo;

  @Autowired
  VillageRepository villageRepo;

  @Autowired
  SrSurveyQuestionRepository questionRepo;

  public List<DataSetDTO> getAllDataSetAndPollution() {
    List<DataSetDTO> result = new ArrayList<DataSetDTO>();
    List<Integer> villageIds = dataSetRepo.getAllVillageId();
    for (Integer villageId : villageIds) {
      String pollution = villageRepo.getOne(villageId).getState();
      result.add(new DataSetDTO(pollution, dataSetFormatter(villageId)));
    }
    return result;
  }

  public List<Question> getDataSetByVillage(int villageId) {
    return this.dataSetFormatter(villageId);
  }

  private List<Question> dataSetFormatter(int villageId) {
    List<DataSet> rawResult = dataSetRepo.findByVillageId(villageId);
    List<Question> questions = new ArrayList<Question>();
    for (DataSet dataSet : rawResult) {
      int index = getExistedQuestionIndex(dataSet, questions);
      if (index > -1) {
        Answer answer = new Answer(dataSet.getAnswer(), dataSet.getCount());
        questions.get(index).getAnswer().add(answer);
      } else {
        String content = dataSet.getQuestion(); // question content
        List<Answer> answers = new ArrayList<Answer>(); // answers
        // answer
        Answer answer = new Answer(dataSet.getAnswer(), dataSet.getCount());
        // add answer
        answers.add(answer);
        // question
        Question newQuestion = new Question(content, answers);
        questions.add(newQuestion);
      }
    }
    return questions;
  }

  private int getExistedQuestionIndex(DataSet dataSet, List<Question> questions) {
    for (int i = 0; i < questions.size(); i++) {
      if (dataSet.getQuestion().equals(questions.get(i).getContent())) {
        return i;
      }
    }
    return -1;
  }
}
