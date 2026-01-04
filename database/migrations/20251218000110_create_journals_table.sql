-- drift:migrate

CREATE TABLE IF NOT EXISTS `journals` (
    `date` DATE NOT NULL,
    `content` TEXT NOT NULL,
    `emotion` VARCHAR(255) NOT NULL,
    `readonly` BOOLEAN NOT NULL,

    PRIMARY KEY (`date`)
);

CREATE UNIQUE INDEX IF NOT EXISTS `index_journals_date` ON `journals`(`date`);

-- drift:rollback

DROP INDEX IF EXISTS `index_journals_date`;

DROP TABLE IF EXISTS `journals`;
