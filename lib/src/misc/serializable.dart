mixin Serializable {
  String serialize(Object object);

  Object deserialize(String string);
}
