String truncateText(String text,int maxCharacterLength) {
    if (text.length > maxCharacterLength) {
      return text.substring(0, maxCharacterLength) + '...';
    } else {
      return text;
    }
  }