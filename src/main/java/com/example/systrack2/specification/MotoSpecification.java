package com.example.systrack2.specification;

import com.example.systrack2.domain.Moto;
import com.example.systrack2.domain.enums.Status;
import org.springframework.data.jpa.domain.Specification;

public class MotoSpecification {

    public static Specification<Moto> modeloLike(String modelo) {
        return (root, query, builder) ->
                modelo == null || modelo.isEmpty() ? null : builder.like(builder.lower(root.get("modelo")), "%" + modelo.toLowerCase() + "%");
    }

    public static Specification<Moto> anoEquals(Integer ano) {
        return (root, query, builder) ->
                ano == null ? null : builder.equal(root.get("ano"), ano);
    }

    public static Specification<Moto> quilometragemEquals(Integer km) {
        return (root, query, builder) ->
                km == null ? null : builder.equal(root.get("quilometragem"), km);
    }

    public static Specification<Moto> quilometragemBetween(Integer minKm, Integer maxKm) {
        return (root, query, builder) -> {
            if (minKm == null && maxKm == null) return null;
            if (minKm != null && maxKm != null) return builder.between(root.get("quilometragem"), minKm, maxKm);
            if (minKm != null) return builder.greaterThanOrEqualTo(root.get("quilometragem"), minKm);
            return builder.lessThanOrEqualTo(root.get("quilometragem"), maxKm);
        };
    }

    public static Specification<Moto> statusEquals(Status status) {
        return (root, query, builder) ->
                status == null ? null : builder.equal(root.get("status"), status);
    }
}

