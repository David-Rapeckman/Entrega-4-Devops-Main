package com.example.systrack2.repository;

import com.example.systrack2.domain.Moto;
import com.example.systrack2.domain.Patio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import java.util.List;
import java.util.Optional;

public interface MotoRepository extends JpaRepository<Moto, Long>, JpaSpecificationExecutor<Moto> {
    Optional<Moto> findByPlaca(String placa);
    List<Moto> findByPatioId(Long patioId);
}
