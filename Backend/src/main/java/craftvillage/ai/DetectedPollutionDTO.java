package craftvillage.ai;

public class DetectedPollutionDTO {
  private int villageId;
  private String state;

  public DetectedPollutionDTO(int villageId, String state) {
    super();
    this.villageId = villageId;
    this.state = state;
  }

  public int getVillageId() {
    return villageId;
  }

  public void setVillageId(int villageId) {
    this.villageId = villageId;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }
}
