package craftvillage.ai;

public class Answer {
  private String value;
  private int count;

  public Answer(String value, int count) {
    super();
    this.value = value;
    this.count = count;
  }

  public String getValue() {
    return value;
  }

  public int getCount() {
    return count;
  }
}
