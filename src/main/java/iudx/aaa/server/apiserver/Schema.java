package iudx.aaa.server.apiserver;

import java.util.concurrent.CountDownLatch;

public enum Schema {
  INSTANCE;

  String schema;
  CountDownLatch latch = new CountDownLatch(1);

  public void setSchema(String schema) {
    if (latch.getCount() > 0) {
      this.schema = schema;
      latch.countDown();
    }
  }

  public String getSchema() {
    try {
      latch.await();
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
    return schema;
  }
}
