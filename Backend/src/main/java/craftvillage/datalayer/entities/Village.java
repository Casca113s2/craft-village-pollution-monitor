package craftvillage.datalayer.entities;

import java.util.HashSet;
import java.util.Set;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import com.fasterxml.jackson.annotation.JsonBackReference;
import craftvillage.corelayer.utilities.ConstantParameter;

@Entity
@Table(name = "VILLAGE", schema = ConstantParameter._SCHEMA_NAME)
public class Village implements java.io.Serializable {

  private int villageId;
  private String villageName;
  private String coordinate;
  private String note;
  private AdWard adWard;
  private int hasAdded;

  private Set<UserSurvey> userSurveys = new HashSet<UserSurvey>();
  private Set<UrUser> households = new HashSet<UrUser>();

  public Village() {}

  public Village(int villageId) {
    this.villageId = villageId;
  }

  @Id
  @GeneratedValue(strategy = GenerationType.AUTO, generator = "VILLAGE_SEQ")
  @Column(name = "VILLAGE_ID", unique = true, nullable = false, precision = 22, scale = 0)
  public int getVillageId() {
    return this.villageId;
  }

  public void setVillageId(int villageId) {
    this.villageId = villageId;
  }

  @Column(name = "HASADDED")
  public int getHasAdded() {
    return this.hasAdded;
  }

  public void setHasAdded(int hasAdded) {
    this.hasAdded = hasAdded;
  }

  // end
  @Column(name = "NOTE", length = 100)
  public String getNote() {
    return note;
  }

  public void setNote(String note) {
    this.note = note;
  }

  @Column(name = "COORDINATE", length = 50)
  public String getCoordinate() {
    return coordinate;
  }

  public void setCoordinate(String coordinate) {
    this.coordinate = coordinate;
  }

  @Column(name = "VILLAGE_NAME", length = 50)
  public String getVillageName() {
    return villageName;
  }

  public void setVillageName(String villageName) {
    this.villageName = villageName;
  }

  @JsonBackReference
  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "WARD_ID")
  public AdWard getAdWard() {
    return adWard;
  }

  @OneToMany(fetch = FetchType.LAZY, mappedBy = "village", targetEntity = UrUser.class)
  public Set<UrUser> getHouseholds() {
    return households;
  }

  public void setHouseholds(Set<UrUser> households) {
    this.households = households;
  }

  public void setAdWard(AdWard adWard) {
    this.adWard = adWard;
  }

  @OrderBy("Id ASC")
  @OneToMany(fetch = FetchType.LAZY, mappedBy = "village", targetEntity = UserSurvey.class)
  public Set<UserSurvey> getUserSurveys() {
    return userSurveys;
  }

  public void setUserSurveys(Set<UserSurvey> userSurveys) {
    this.userSurveys = userSurveys;
  }


  static public void showInfoVillage(Village village) {
    System.out.println("villageId : " + village.getVillageId());
    System.out.println("getCoordinate : " + village.getCoordinate());
    System.out.println("getNote : " + village.getNote());
    System.out.println("getHasAdded : " + village.getHasAdded());
    System.out.println("getVillageName : " + village.getVillageName());
    System.out.println("get ward id : " + village.getAdWard().getWardId());

  }

}
