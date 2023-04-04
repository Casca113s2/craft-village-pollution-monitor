package craftvillage.datalayer.entities.dto;

import craftvillage.datalayer.entities.Village;

public class MapVillageDTO {
  private int villageId;
  private int wardId;
  private String coordinate;
  private String villageName;
  private String note;

  public MapVillageDTO(Village village) {
    this.villageId = village.getVillageId();
    this.wardId = village.getAdWard().getWardId();
    this.coordinate = village.getCoordinate();
    this.villageName = village.getVillageName();
    this.note = village.getNote();
  }

  public static MapVillageDTO from(Village village) {
    return new MapVillageDTO(village);
  }

  public int getVillageId() {
    return villageId;
  }

  public int getWardId() {
    return wardId;
  }

  public String getCoordinate() {
    return coordinate;
  }

  public String getVillageName() {
    return villageName;
  }

  public String getNote() {
    return note;
  }
}
