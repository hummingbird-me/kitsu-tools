$(function() {
  return $("form.autosubmit select.autosubmit").change(function() {
    return $("form.autosubmit").submit();
  });
});
