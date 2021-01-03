---
title: Home
---

<%
post = @items['/posts/2020-12-23-test.*']
%>

<%= post.reps[:excerpt].compiled_content(:snapshot => :excerpt) %>
