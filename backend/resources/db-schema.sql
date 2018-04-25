CREATE TABLE openPullRequestsTable
           (id INT AUTO_INCREMENT,
            productName VARCHAR(255),
            repository VARCHAR(255),
            prTitle VARCHAR(255),
            gitId VARCHAR(255),
            durationWeeks VARCHAR(255),
            durationDays INT,
            prStatus VARCHAR(255),
            prURL VARCHAR(255),
            lastCommitDay VARCHAR(255),
            PRIMARY KEY (id))ENGINE INNODB;
