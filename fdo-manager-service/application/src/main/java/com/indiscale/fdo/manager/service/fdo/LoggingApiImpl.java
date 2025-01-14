package com.indiscale.fdo.manager.service.fdo;

import com.indiscale.fdo.manager.service.BaseController;
import com.indiscale.fdo.manager.service.LogRecord;
import com.indiscale.fdo.manager.service.MemoryOperationsLoggerSink;
import com.indiscale.fdo.manager.service.api.model.DigitalObject;
import com.indiscale.fdo.manager.service.api.model.ListLogEvents200Response;
import com.indiscale.fdo.manager.service.api.model.OperationsLogRecord;
import com.indiscale.fdo.manager.service.api.model.OperationsLogRecordAttributes;
import com.indiscale.fdo.manager.service.api.model.TargetRepositories;
import com.indiscale.fdo.manager.service.api.operation.LoggingApi;
import jakarta.validation.Valid;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RestController;

@RestController
@CrossOrigin(origins = {"${react-dev-server}"})
public class LoggingApiImpl extends BaseController implements LoggingApi {

  @Override
  public ResponseEntity<ListLogEvents200Response> listLogEvents(
      @Valid Integer pageNumber, @Valid Integer pageSize) {
    List<OperationsLogRecord> data = new ArrayList<>();
    for (LogRecord r : MemoryOperationsLoggerSink.getLogRecords(pageNumber, pageSize)) {
      OperationsLogRecordAttributes attr = new OperationsLogRecordAttributes();
      attr.timestamp(
          OffsetDateTime.ofInstant(Instant.ofEpochMilli(r.getTimestamp()), ZoneId.of("UTC")));
      attr.operation(OperationsLogRecordAttributes.OperationEnum.fromValue(r.getOperation()));
      if (r.getRepository() != null) {
        attr.setRepositories(new TargetRepositories().fdo(r.getRepository().getId()));
      }
      if (r.getFdo() != null) {
        attr.fdo(new DigitalObject().pid(r.getFdo().getPID()));
        attr.getFdo().setIsFdo(r.getFdo().isFDO());
        if (attr.getFdo().getIsFdo()) {
          attr.getFdo().setDataPid(r.getFdo().toFDO().getData().getPID());
          attr.getFdo().setMetadataPid(r.getFdo().toFDO().getMetadata().getPID());
        }
      } else {
        continue;
      }
      data.add(
          new OperationsLogRecord()
              .id(r.getId())
              .type(OperationsLogRecord.class.getSimpleName())
              .attributes(attr));
    }

    return ResponseEntity.ok(new ListLogEvents200Response().data(data));
  }
}
