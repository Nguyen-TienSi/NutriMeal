package com.uth.nutriai.converter;

import org.bson.BsonReader;
import org.bson.BsonType;
import org.bson.BsonWriter;
import org.bson.codecs.Codec;
import org.bson.codecs.DecoderContext;
import org.bson.codecs.EncoderContext;

import java.time.Instant;
import java.util.Date;

public class InstantCodec implements Codec<Instant> {
    @Override
    public Instant decode(BsonReader bsonReader, DecoderContext decoderContext) {

        BsonType bsonType = bsonReader.getCurrentBsonType();
        if (bsonType == BsonType.NULL) {
            bsonReader.readNull();
            return null;
        }
        long millis = bsonReader.readDateTime();
        return Instant.ofEpochMilli(millis);
    }

    @Override
    public void encode(BsonWriter bsonWriter, Instant instant, EncoderContext encoderContext) {
        if (instant != null) {
            bsonWriter.writeDateTime(Date.from(instant).getTime());
        } else {
            bsonWriter.writeNull();
        }
    }

    @Override
    public Class<Instant> getEncoderClass() {
        return Instant.class;
    }
}
