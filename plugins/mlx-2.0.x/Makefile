#
# Copyright (C) 2012 Auburn University
# Copyright (C) 2012 Mellanox Technologies
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#  
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
# either express or implied. See the License for the specific language 
# governing permissions and  limitations under the License.
#
#

CPATH=.
CPATH := $(CPATH):hadoop-mapreduce-client-core-3.0.0-SNAPSHOT.jar
CPATH := $(CPATH):hadoop-common-2.0.5-alpha.jar
CPATH := $(CPATH):commons-logging-1.1.1.jar
CPATH := $(CPATH):hadoop-mapreduce-client-core-2.0.5-alpha.jar
CPATH := $(CPATH):hadoop-yarn-server-nodemanager-2.0.5-alpha.jar
CPATH := $(CPATH):hadoop-yarn-common-2.0.5-alpha.jar
CPATH := $(CPATH):hadoop-yarn-api-2.0.5-alpha.jar



TARGET=uda-hadoop-2.0.x.jar

FILES=com/mellanox/hadoop/mapred/*.java \
      org/apache/hadoop/mapred/*.java \
			../shared/com/mellanox/hadoop/mapred/*[^1].java \
			../shared/org/apache/hadoop/mapred/*[^1].java

all: $(TARGET)

$(TARGET):$(FILES)
	rm -rf out
	mkdir -p out
	CLASSPATH=$(CPATH) $(JAVA_HOME)/bin/javac -d out -sourcepath ../shared/:. $(FILES)
	$(JAVA_HOME)/bin/jar -cvf $(TARGET) -C out com -C out org
	rm -rf out

clean:
	rm -rf $(TARGET) out
