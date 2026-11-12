-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 12/11/2026 às 01:51
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `twitter_clone`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `amizades`
--

CREATE TABLE `amizades` (
  `id` int(11) NOT NULL,
  `email_solicitante` varchar(100) DEFAULT NULL,
  `email_solicitado` varchar(100) DEFAULT NULL,
  `status` enum('pendente','aceito') DEFAULT 'pendente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `amizades`
--

INSERT INTO `amizades` (`id`, `email_solicitante`, `email_solicitado`, `status`) VALUES
(1, 'vinicius@email.com', 'mauro@email.com', 'aceito'),
(2, 'admin@email.com', 'mauro@email.com', 'pendente'),
(3, 'admin@email.com', 'vinicius@email.com', 'pendente');

-- --------------------------------------------------------

--
-- Estrutura para tabela `comentarios`
--

CREATE TABLE `comentarios` (
  `id` int(11) NOT NULL,
  `postagem_id` int(11) DEFAULT NULL,
  `email_autor` varchar(100) DEFAULT NULL,
  `texto` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `comentarios`
--

INSERT INTO `comentarios` (`id`, `postagem_id`, `email_autor`, `texto`) VALUES
(1, 2, 'mauro@email.com', 'beleza!!!!'),
(2, 2, 'vinicius@email.com', 'combinado!!');

-- --------------------------------------------------------

--
-- Estrutura para tabela `curtidas`
--

CREATE TABLE `curtidas` (
  `id` int(11) NOT NULL,
  `postagem_id` int(11) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `curtidas`
--

INSERT INTO `curtidas` (`id`, `postagem_id`, `email`) VALUES
(1, 2, 'vinicius@email.com'),
(2, 1, 'vinicius@email.com'),
(3, 2, 'mauro@email.com'),
(4, 1, 'mauro@email.com'),
(5, 3, 'admin@email.com'),
(6, 2, 'admin@email.com'),
(7, 1, 'admin@email.com'),
(8, 3, 'vinicius@email.com');

-- --------------------------------------------------------

--
-- Estrutura para tabela `postagens`
--

CREATE TABLE `postagens` (
  `id` int(11) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `texto` text DEFAULT NULL,
  `foto_caminho` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `postagens`
--

INSERT INTO `postagens` (`id`, `email`, `texto`, `foto_caminho`) VALUES
(1, 'vinicius@email.com', 'postagem de teste', ''),
(2, 'mauro@email.com', 'aula de desenvolvimento para dispositivos moveis hoje!!!!!!!', ''),
(3, 'admin@email.com', 'ADMINISTRADOR!', '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuarios`
--

INSERT INTO `usuarios` (`id`, `nome`, `email`, `senha`) VALUES
(1, 'vinicius', 'vinicius@email.com', '123456'),
(2, 'Administrador', 'admin@email.com', '123456'),
(3, 'mauro', 'mauro@email.com', '123456');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `amizades`
--
ALTER TABLE `amizades`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `comentarios`
--
ALTER TABLE `comentarios`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `curtidas`
--
ALTER TABLE `curtidas`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `postagens`
--
ALTER TABLE `postagens`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `amizades`
--
ALTER TABLE `amizades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `comentarios`
--
ALTER TABLE `comentarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `curtidas`
--
ALTER TABLE `curtidas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `postagens`
--
ALTER TABLE `postagens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
