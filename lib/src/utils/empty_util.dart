bool isEmpty(Object object) {
  if (object == null) {
    return true;
  }

  if (object is String) {
    return object.isEmpty;
  }

  if (object is Iterable) {
    return object.isEmpty;
  }

  if (object is Map) {
    return object.isEmpty;
  }

  return false;
}

bool isNotEmpty(Object object) {
  return !isEmpty(object);
}
