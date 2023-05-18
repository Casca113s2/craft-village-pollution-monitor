package craftvillage.datalayer.entities;
// Generated Mar 10, 2020 9:28:01 AM by Hibernate Tools 4.3.5.Final

import java.util.Date;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonFormat;
import craftvillage.corelayer.utilities.ConstantParameter;

/**
 * UserSurvey generated by hbm2java
 */
@Entity
@Table(name = "USER_SURVEY", schema = ConstantParameter._SCHEMA_NAME)
public class UserSurvey implements java.io.Serializable {
  private static final long serialVersionUID = 1L;
  private int id;
  private UrUser urUser;
  private String isTemporary;
  @Temporal(TemporalType.TIMESTAMP)
  private Date dateSubmitSurvey;
  private String image;
  private String coordinate;
  private String pollution;
  private String note;
  private Boolean warning;
  private Boolean checked;
  private Village village;

  @Id
  @OrderBy("id ASC")
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "ID", unique = true, nullable = false, precision = 22, scale = 0)
  public int getId() {
    return this.id;
  }

  public void setId(int id) {
    this.id = id;
  }

  @JsonBackReference
  @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
  @JoinColumn(name = "UR_ID", nullable = false)
  public UrUser getUrUser() {
    return this.urUser;
  }

  public void setUrUser(UrUser urUser) {
    this.urUser = urUser;
  }

  @Column(name = "IS_TEMPORARY", length = 40)
  public String getIsTemporary() {
    return this.isTemporary;
  }

  public void setIsTemporary(String isTemporary) {
    this.isTemporary = isTemporary;
  }

  // end
  @JsonBackReference
  @ManyToOne(fetch = FetchType.LAZY, targetEntity = Village.class)
  @JoinColumn(name = "VILLAGE_ID")
  public Village getVillage() {
    return village;
  }

  public void setVillage(Village village) {
    this.village = village;
  }

  @JsonFormat(pattern = "dd-MM-yyyy hh:mm:ss")
  @Temporal(TemporalType.TIMESTAMP)
  @Column(name = "DATE_SUBMIT_SURVEY", precision = 126, scale = 0)
  @OrderBy("DESC")
  public Date getDateSubmitSurvey() {
    return dateSubmitSurvey;
  }

  public void setDateSubmitSurvey(Date dateSubmitSurvey) {
    this.dateSubmitSurvey = dateSubmitSurvey;
  }

  @Column(name = "IMAGE", length = 1024 * 1024)
  public String getImage() {
    return this.image;
  }

  public void setImage(String image) {
    this.image = image;
  }

  @Column(name = "COORDINATE")
  public String getCoordinate() {
    return this.coordinate;
  }

  public void setCoordinate(String coordinate) {
    this.coordinate = coordinate;
  }

  @Column(name = "POLLUTION")
  public String getPollution() {
    return this.pollution;
  }

  public void setPollution(String pollution) {
    this.pollution = pollution;
  }

  @Column(name = "NOTE")
  public String getNote() {
    return note;
  }

  public void setNote(String note) {
    this.note = note;
  }

  @Column(name = "WARNING")
  public Boolean getWarning() {
    return warning;
  }

  public void setWarning(Boolean warning) {
    this.warning = warning;
  }

  @Column(name = "CHECKED", columnDefinition = "boolean default TRUE")
  public Boolean getChecked() {
    return checked;
  }

  public void setChecked(Boolean checked) {
    this.checked = checked;
  }
}
